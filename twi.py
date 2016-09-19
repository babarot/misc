import tweepy
import time
import datetime
from datetime import datetime as dt
import json
import requests

def initialize():
    consumer_key = "********************************************************************************"
    consumer_secret = "********************************************************************************"
    access_token = "********************************************************************************"
    access_token_secret = "********************************************************************************"

    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    api = tweepy.API(auth)

    keywords =['zplug']
    query = ' OR '.join(keywords)

    for tweet in api.search(q=query, count=100):
        if tweet.created_at.strftime('%Y-%m-%d') == dt.today().strftime('%Y-%m-%d'):
            postToSlack(tweet)

def postToSlack(tweet):
    payload = {
            "channel": "#random-jp",
            "username": "Searcher of Tweets",
            "icon_emoji": ":bird:",
            #"text": tweet.text,
            "attachments": [
                {
                    #"fallback": "Required plain-text summary of the attachment.",
                    "color": "#55acee",
                    #"pretext": "Optional text that appears above the attachment block",
                    "author_name": "@" + tweet.author.screen_name,
                    "author_link": "https://twitter.com/" + tweet.author.screen_name,
                    "author_icon": tweet.author.profile_image_url_https,
                    "title": tweet.author.name + "'s tweet!",
                    "title_link": "https://twitter.com/" + tweet.author.screen_name + "/status/" + tweet.id_str,
                    "text": tweet.text,
                    "fields": [
                        {
                            "title": "Retweets",
                            "value": tweet.retweet_count,
                            "short": True
                            },
                        {
                            "title": "Likes",
                            "value": tweet.favorite_count,
                            "short": True
                            }
                        ],
                    #"image_url": tweet.author.profile_image_url_https,
                    #"thumb_url": tweet.author.profile_image_url_https,
                    "footer": "Twitter",
                    "footer_icon": "http://www.freeiconspng.com/uploads/twitter-icon-download-18.png",
                    "ts": time.mktime(tweet.created_at.timetuple())
                    }
                ]
            }
    url = "********************************************************************************"
    payloadJson = json.dumps(payload)
    requests.post(url, data=payloadJson)

def main():
    initialize()

if __name__ == "__main__":
    main()
