#!/bin/bash
# Weather module using wttr.in — returns JSON for waybar

LOCATION="Arlington"  # change if you want

# Nerd font icons per WWO condition code
declare -A ICONS=(
    [113]="󰖙" # Sunny
    [116]="󰖕" # PartlyCloudy
    [119]="󰖐" # Cloudy
    [122]="󰖐" # VeryCloudy
    [143]="󰖑" # Fog
    [176]="󰼳" # LightShowers
    [179]="󰖘" # LightSleetShowers
    [182]="󰖘" # LightSleet
    [185]="󰖘" # LightSleet
    [200]="󰖓" # Thunder
    [227]="󰖘" # LightSnow
    [230]="󰼶" # HeavySnow
    [248]="󰖑" # Fog
    [260]="󰖑" # Fog
    [263]="󰼳" # LightShowers
    [266]="󰼳" # LightRain
    [281]="󰖘" # LightSleet
    [284]="󰖘" # LightSleet
    [293]="󰼳" # LightRain
    [296]="󰼳" # LightRain
    [299]="󰖖" # HeavyShowers
    [302]="󰖖" # HeavyRain
    [305]="󰖖" # HeavyShowers
    [308]="󰖖" # HeavyRain
    [311]="󰖘" # LightSleet
    [314]="󰖘" # LightSleet
    [317]="󰖘" # LightSleet
    [320]="󰖘" # LightSnow
    [323]="󰖘" # LightSnowShowers
    [326]="󰖘" # LightSnowShowers
    [329]="󰼶" # HeavySnow
    [332]="󰼶" # HeavySnow
    [335]="󰼶" # HeavySnowShowers
    [338]="󰼶" # HeavySnow
    [350]="󰖘" # LightSleet
    [353]="󰼳" # LightShowers
    [356]="󰖖" # HeavyShowers
    [359]="󰖖" # HeavyRain
    [362]="󰖘" # LightSleetShowers
    [365]="󰖘" # LightSleetShowers
    [368]="󰖘" # LightSnowShowers
    [371]="󰼶" # HeavySnowShowers
    [374]="󰖘" # LightSleetShowers
    [377]="󰖘" # LightSleet
    [386]="󰖓" # ThunderyShowers
    [389]="󰖓" # ThunderyHeavyRain
    [392]="󰖓" # ThunderySnowShowers
    [395]="󰼶" # HeavySnowShowers
)

# Fetch weather (json1 format, minimal payload)
DATA=$(curl -s --max-time 6 "wttr.in/${LOCATION}?format=j1")

if [ -z "$DATA" ]; then
    echo '{"text":"󰼯 --°","tooltip":"Weather unavailable","class":"offline"}'
    exit 0
fi

CODE=$(echo "$DATA"    | jq -r '.current_condition[0].weatherCode')
TEMP_F=$(echo "$DATA"  | jq -r '.current_condition[0].temp_F')
FEELS=$(echo "$DATA"   | jq -r '.current_condition[0].FeelsLikeF')
DESC=$(echo "$DATA"    | jq -r '.current_condition[0].weatherDesc[0].value')
HUMID=$(echo "$DATA"   | jq -r '.current_condition[0].humidity')
WIND=$(echo "$DATA"    | jq -r '.current_condition[0].windspeedMiles')
AREA=$(echo "$DATA"    | jq -r '.nearest_area[0].areaName[0].value')

ICON="${ICONS[$CODE]:-󰼯}"

# Build a rich tooltip with today + tomorrow forecast
TOOLTIP="<big>${ICON}  ${TEMP_F}°F in ${AREA}</big>\n"
TOOLTIP+="<i>${DESC}</i>  ·  feels like ${FEELS}°\n"
TOOLTIP+="\n💧 Humidity: ${HUMID}%   💨 Wind: ${WIND} mph\n"
TOOLTIP+="\n<b>Today</b>  ·  "
TOOLTIP+="H: $(echo "$DATA" | jq -r '.weather[0].maxtempF')°  "
TOOLTIP+="L: $(echo "$DATA" | jq -r '.weather[0].mintempF')°\n"
TOOLTIP+="<b>Tomorrow</b>  ·  "
TOOLTIP+="H: $(echo "$DATA" | jq -r '.weather[1].maxtempF')°  "
TOOLTIP+="L: $(echo "$DATA" | jq -r '.weather[1].mintempF')°"

printf '{"text":"%s  %s°","tooltip":"%s","class":"weather"}\n' \
    "$ICON" "$TEMP_F" "$TOOLTIP"
