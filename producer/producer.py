import csv
import io
import json
import os
import re
import time
from pathlib import Path

# ЗАМЕНИТЕ ДЛЯ СВОЕГО DATASET: поле стабильного ключа.
ID_COLUMN = "id"

def read_rows(path, mode):
    text = Path(path).read_text(encoding="utf-8-sig")
    if mode == "csv":
        # Для обычного CSV. При необходимости измените delimiter.
        reader = csv.DictReader(io.StringIO(text), delimiter=",")
        for row in reader:
            if None in row or any(v is None for v in row.values()):
                raise ValueError("Неверное число CSV-колонок")
            yield row, json.dumps(row, ensure_ascii=False)
        return
    if mode != "mock_export":
        raise ValueError("INPUT_MODE должен быть csv или mock_export")
    # ТОЛЬКО для приложенного MOCK_DATA из ЛР3.csv.
    # Не переносите этот адаптер на произвольный CSV.
    header = text.splitlines()[0].rstrip(";").split(",")
    if len(header) != 50 or header[38] != "product_description":
        raise ValueError("Неожиданная структура MOCK_DATA")
    blocks = re.split(r'(?m)^(?="?\d+,)', text)[1:]
    if not blocks:
        raise ValueError("Не найдены записи")
    for original in blocks:
        value = original.strip().rstrip(";")
        if value.startswith('"') and value.endswith('"'):
            value = value[1:-1].replace('""', '"')
        left = value.split(",", 38)
        right = left[-1].rsplit(",", 11)
        values = left[:-1] + right
        if len(left) != 39 or len(right) != 12:
            raise ValueError("Не удалось выделить 50 полей")
        yield dict(zip(header, values)), original

def main():
    from kafka import KafkaProducer
    mode = os.getenv("INPUT_MODE", "csv")
    dataset = os.environ["DATASET_ID"]
    records = list(read_rows(os.environ["INPUT_FILE"], mode))
    ids = [r[0][ID_COLUMN].strip() for r in records]
    if not records or not all(ids) or len(set(ids)) != len(ids):
        raise ValueError("Пустой файл, пустые или повторные ключи")
    if mode == "mock_export" and ids != [str(i) for i in range(1, 41)]:
        raise ValueError("Ожидались 40 записей исходного примера")
    if os.getenv("CHECK_ONLY") == "1":
        print(f"INPUT OK: {len(records)} records, unique keys")
        return
    # Только контролируемый эксперимент из лабораторной 3.
    if os.getenv("DEMO_APPEND") == "1":
        row = records[0][0].copy()
        row.update(id="41", sale_quantity="2",
                   sale_total_price="100.00", sale_date="12/31/2021")
        records.append((row, json.dumps(row, ensure_ascii=False)))
    producer = KafkaProducer(
        bootstrap_servers=os.environ["KAFKA_BOOTSTRAP"],
        acks="all", retries=5,
        max_in_flight_requests_per_connection=1,
        key_serializer=lambda x: x.encode("utf-8"),
        value_serializer=lambda x: json.dumps(
            x, ensure_ascii=False).encode("utf-8"))
    schema = {
        "type": "struct", "name": "RawEvent", "optional": False,
        "fields": [{"field": x, "type": "string", "optional": False}
                   for x in ["event_id", "dataset_id", "payload",
                             "source_record"]]}
    size = int(os.getenv("BATCH_SIZE", "50"))
    if size <= 0:
        raise ValueError("BATCH_SIZE должен быть положительным")
    try:
        for offset in range(0, len(records), size):
            pending = []
            for row, original in records[offset:offset + size]:
                key = dataset + ":" + row[ID_COLUMN].strip()
                event = {"schema": schema, "payload": {
                    "event_id": key, "dataset_id": dataset,
                    "payload": json.dumps(row, ensure_ascii=False),
                    "source_record": original}}
                pending.append(producer.send(
                    os.environ["TOPIC"], key=key, value=event))
            for future in pending:
                future.get(timeout=60)
            producer.flush(timeout=60)
            print(f"ACK batch={offset // size + 1} size={len(pending)}")
            time.sleep(1)
    finally:
        producer.close(timeout=10)

if __name__ == "__main__":
    main()
