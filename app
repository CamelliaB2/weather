import requests
import json
import streamlit as st
from datetime import datetime
from urllib.request import urlopen



API_KEY = 'cbb4d7df683341cba8c513dceee9e0f8'

BASE_URL = 'https://api.openweathermap.org/data/2.5/forecast'

st.title('Weather App')

def get_user_location():
    url = 'http://ipinfo.io/json'
    response = urlopen(url)
    data = json.load(response)
    return data.get('city')
    

# Function to get weather data
def get_weather(city_name):
    request_url = f"{BASE_URL}?q={city_name}&appid={API_KEY}&units=imperial"

    # Send a GET request to the API
    response = requests.get(request_url)

    # Check if the response is successful
    if response.status_code == 200:
        # Parse the JSON response
        data = response.json()
        forecast_list = data['list']

        st.write(f"5-Day Weather Forecast for {city_name} (3hr intervals):\n")
        
        for forecast in forecast_list:
            timestamp = datetime.fromtimestamp(forecast['dt']).strftime('%Y-%m-%d %H:%M:%S')
            temp = forecast['main']['temp']
            description = forecast['weather'][0]['description']
            icon = forecast['weather'][0]['icon']

            # Print out the timestamp, temperature, and weather description
            st.write(f"Date & Time: {timestamp}")
            st.write(f"Temperature: {temp}°F")
            st.write(f"Weather: {description.capitalize()}")
            icon_url = f"http://openweathermap.org/img/wn/{icon}@2x.png"
            st.image(icon_url, width=100)  
            st.write("-" * 40)

    else:
        # Print an error message if something goes wrong
        st.write("Error: Unable to get weather data")
    
city_name = st.text_input("Enter a city:")

if st.button("Get Current Location"):
    city = get_user_location()
    get_weather(city)
else:
    # Allow user to input a city manually
    if city_name:
        get_weather(city_name)
