from flask import Flask, request, jsonify
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer
from nltk.corpus import stopwords
from collections import Counter

nltk.download('vader_lexicon')
nltk.download('stopwords')
nltk.download('punkt')

sia = SentimentIntensityAnalyzer()

app = Flask(__name__)

# Text preprocessing
def preprocess_text(text):
    words = nltk.word_tokenize(text.lower())
    stop_words = set(stopwords.words('english'))
    filtered_words = [word for word in words if word.isalnum() and word not in stop_words]
    return filtered_words

# Sentiment analysis
def analyze_sentiment(text):
    sentiment_scores = sia.polarity_scores(text)
    return sentiment_scores

# Topic analysis using word frequency
def analyze_topic(words):
    word_freq = Counter(words)
    most_common_words = word_freq.most_common(5)
    return most_common_words

@app.route('/analyze', methods=['POST'])
def analyze():
    data = request.json
    if not data or 'text' not in data:
        return jsonify({"error": "Invalid input"}), 400

    text = data['text']
    words = preprocess_text(text)
    sentiment = analyze_sentiment(text)
    topic = analyze_topic(words)

    return jsonify({
        "sentiment": sentiment,
        "topic": topic
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
