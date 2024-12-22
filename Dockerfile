FROM python:3.9-slim

WORKDIR /app

# Install dependencies
COPY src/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Download NLTK data
RUN python -m nltk.downloader vader_lexicon stopwords punkt punkt_tab

# Copy application code
COPY . .

# Expose port and define the entry point
EXPOSE 5000
CMD ["python", "src/text_analysis_service.py"]
