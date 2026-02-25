# Function to fetch Data (Starter code)
def fetch_text(raw_url):
    import requests
    from pathlib import Path
    import hashlib

    CACHE_DIR = Path("cs_110_content/text_cache")
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    def _url_to_filename(url):
        url_hash = hashlib.sha1(url.encode("utf-8")).hexdigest()[:12]
        return CACHE_DIR / f"{url_hash}.txt"

    cache_path = _url_to_filename(raw_url)

    SUCCESS_MSG = "✅ Text fetched."
    FAILURE_MSG = "❌ Failed to fetch text."
    try:
        if not cache_path.exists():
            response = requests.get(raw_url, timeout=10)
            response.raise_for_status()
            text_data = response.text
            cache_path.write_text(text_data, encoding="utf-8")
        print(SUCCESS_MSG)
        return cache_path.read_text(encoding="utf-8")

    except Exception as e:
        print(FAILURE_MSG)
        print(f"Error: {e}")
        return ""

# Save the text as variable 
Why_I_Write_URL = "https://naimdlf.github.io/portfolio/Text/Why_I_Write_by_George_Orwell.txt"
Why_I_Write_text = fetch_text(Why_I_Write_URL)

# Statistics about data
def print_text_stats(text):
    num_chars = len(text)

    lines = text.splitlines()
    num_lines = len(lines)

    num_words = 0
    for line in lines:
        words_in_line = line.split()
        num_words_in_line = len(words_in_line)
        num_words += num_words_in_line

    print(f"Number of characters: {num_chars}")
    print(f"Number of lines: {num_lines}")
    print(f"Number of words: {num_words}")

def get_word_counts(text):
    word_counts = {}
    lines = text.splitlines()
    for line in lines:
        words = line.split()
        for word in words:
            word = word.lower()
            if word in word_counts:
                word_counts[word] += 1
            else:
                word_counts[word] = 1
    return word_counts

def print_top_10_frequent_words(text):
    import operator
    word_counts = get_word_counts(text)
    sorted_word_counts = dict(sorted(word_counts.items(), key=operator.itemgetter(1), reverse=True))
    top_10_words = list(sorted_word_counts.items())[:10]  # Get the top 10 words and counts
    for word, count in top_10_words:
        print(f"{word}: {count}")

import spacy
nlp = spacy.load('en_core_web_sm')

def word_tokenization_normalization(text):
    text = text.lower()  # lowercase
    doc = nlp(text)     # loading text into model

    words_normalized = []
    for word in doc:
        if word.text != '\n' \
        and not word.is_stop \
        and not word.is_punct \
        and not word.like_num \
        and len(word.text.strip()) > 2:
            word_lemmatized = str(word.lemma_)
            words_normalized.append(word_lemmatized)

    return words_normalized

def create_word_frequency_dict(words):
    """
    Creates a word frequency dictionary from a list of words.

    Args:
    words (list): A list of words.

    Returns:
    dict: A dictionary where keys are words and values are their frequencies.
    """
    word_freq = {}
    for word in words:
        if word in word_freq:
            word_freq[word] += 1
        else:
            word_freq[word] = 1
    return word_freq

def print_top_words(word_freq, top_n=15):
    """
    Prints the top N most frequent words and their counts.

    Args:
        word_freq (dict): A dictionary of word frequencies.
        top_n (int): The number of top words to print. Defaults to 15.
    """
    import operator
    sorted_word_counts = dict(sorted(word_freq.items(), key=operator.itemgetter(1), reverse=True))
    top_words = list(sorted_word_counts.items())[:top_n]

    for word, count in top_words:
        print(f"{word}: {count}")

# Now call the functions to see the stats and word counts:

print_text_stats(Why_I_Write_text)

word_counts = get_word_counts(Why_I_Write_text)
print(word_counts)

print_top_10_frequent_words(Why_I_Write_text)

meaningful_words = word_tokenization_normalization(Why_I_Write_text)
print(meaningful_words)

word_freq_dict = create_word_frequency_dict(meaningful_words)
print_top_words(word_freq_dict)
