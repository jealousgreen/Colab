import psycopg2


def main():
    with psycopg2.connect(database='demo', user='postgres', password='1234') as conn:
        cur = conn.cursor()

        cur.execute("select * from aircrafts_vw")

        result = cur.fetchall()

        for i in result:
            print(i)


if __name__ == '__main__':
    main()
