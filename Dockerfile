FROM python:3.12-slim

WORKDIR /app

COPY Home.py /app/
COPY pages/ /app/pages
COPY images/ /app/images
COPY Pipfile /app/

RUN pip install pipenv
RUN pipenv lock
RUN pipenv sync

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["pipenv", "run", "streamlit", "run", "Home.py", "--server.port=8501"]