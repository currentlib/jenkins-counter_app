FROM python:3.6-alpine3.9

COPY requirements.txt .

RUN pip install -r requirements.txt

WORKDIR /flask

RUN mkdir logs

COPY /hits/app.py . 

EXPOSE 5000

EntryPOINT ["/usr/local/bin/python3"]

CMD ["app.py"]
