# 1. 파이썬 베이스 이미지 선택
FROM python:3.11-slim

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. 필요한 시스템 패키지 설치 (Poetry 설치용)
RUN apt-get update && apt-get install -y curl && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    apt-get clean

# 4. Poetry 경로 설정
ENV PATH="/root/.local/bin:$PATH"

# 5. 의존성 파일 먼저 복사 (캐싱 활용)
COPY pyproject.toml poetry.lock* ./

# 6. 라이브러리 설치 (가상환경 생성 안 함)
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# 7. 나머지 소스 코드 복사
COPY . .

# 8. 앱 실행 (포트는 본인의 앱 설정에 맞게 수정하세요)
CMD ["python", "main.py"]