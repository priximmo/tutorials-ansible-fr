FROM python:3.9-alpine

RUN apk upgrade --update && \
		apk add --no-cache bash && \
		apk add --no-cache curl && \
		pip3 install --upgrade pip

COPY . /app

WORKDIR /app

RUN pip3 install -r requirements.txt

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]

