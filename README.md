<img align="right" height="225" src="https://github.com/Barreloofy/monoTENKI/blob/main/monoTENKIPhoto.png"  />

<h3 align="left">Installation</h3>

 1. Download zip or clone (git clone https://github.com/Barreloofy/monoTENKI.git) 
 
 2. Open project in Xcode 
 
 3. Add key (WeatherAPI.comAPIKey) as string type to info.plist and provide your API key from WeatherAPI.com

   API Response Fields:
     
     Current Weather:
       
       temp_c
       
       text
       
       wind_kph
       
       wind_dir
       
       precip_mm
       
       humidity
       
       guts_kph
       
       windchill_c
     
     forecastDay:
       
       date
     
     Day:
       
       maxtemp_c
       
       mintemp_c
       
       avgtemp_c
       
       text
     
     Hour:
       
       time
       
       temp_c
       
       text

 
 The project was build with Swift 6 on Xcode 16.2 with a custom pattern, not MVVM, that is akin to Apples MV pattern
