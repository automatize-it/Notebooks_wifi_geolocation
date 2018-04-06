# windows_cmd_parse_netsh_wlan_info

This cmd script parses result of 'netsh wlan show all' command. 

Then: 
1. It forms Yandex Maps json file with local Wi-Fi data;
2. Sends data to Yandex Locator service and gets coordinates. You need your own API key stored in 'yaapikey.txt';
3. Opens Google Maps in Firefox with obtained coordinates.

Works only with RUSSIAN system language. Script file MUST be coded in OEM866.

