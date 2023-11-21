//IPv4 session
// const String ipv4 = "10.10.10.218";
// const String ipv4 = "172.16.3.64";
const String ipv4 = "172.20.10.4";
// const String ipv4 = "10.11.9.101";

//Header session
const Map<String, String> headers = {
  "Access-Control-Allow-Origin": "*",
  'Content-Type': 'application/json',
  'Accept-Language': 'th',
  'Accept': '*/*'
};

//Farmer session
// ignore: prefer_interpolation_to_compose_strings
const String baseURL = "http://" + ipv4 + ":8080/sharehub_ws";
