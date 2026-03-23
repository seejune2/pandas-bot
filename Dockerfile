FROM python:3.11-slim

WORKDIR /app

# 빌드 도구 설치
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && apt-get clean

# Poetry 설치
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# [수정된 부분] pyproject.toml 뿐만 아니라 README.md도 미리 복사합니다.
# lock 파일이 없을 수도 있으므로 *를 붙여줍니다.
COPY pyproject.toml poetry.lock* README.md ./

# 의존성 설치 (README가 있어서 이제 에러가 나지 않습니다)
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi --no-root

# 나머지 소스 코드 복사
COPY . .

# 전체 설치
RUN poetry install --no-interaction --no-ansi

CMD ["python", "main.py"]