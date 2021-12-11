var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/blvt/tokenInfo'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/blvt/subscribe?tokenName=&cost=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/blvt/subscribe/record?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/blvt/redeem?tokenName=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/blvt/redeem/record?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/blvt/userLimit?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/pools'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/liquidity?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/bswap/liquidityAdd?poolId=&asset=&quantity=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/bswap/liquidityRemove?poolId=&type=&shareAmount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/liquidityOps?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/quote?quoteAsset=&baseAsset=&quoteQty=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/bswap/swap?quoteAsset=&baseAsset=&quoteQty=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/swap?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/poolConfigure?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/addLiquidityPreview?poolId=&type=&quoteAsset=&quoteQty=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bswap/removeLiquidityPreview?poolId=&type=&quoteAsset=&shareAmount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/c2c/orderMatch/listUserOrderHistory?tradeType=BUY&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/virtualSubAccount?subAccountString=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/list?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/sub/transfer/history?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/futures/internalTransfer?email&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/futures/internalTransfer?fromEmail&toEmail&futuresType&asset&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'X-MBX-APIKEY': 'api-key',
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v3/sub-account/assets?email=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/spotSummary?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/capital/deposit/subAddress?email&coin&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/capital/deposit/subHisrec?email&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/status?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/margin/enable?email=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/margin/account?email=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/margin/accountSummary?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/futures/enable?email&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/futures/account?email=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/futures/accountSummary?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/futures/positionRisk?email=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/futures/transfer?email=&asset&amount&type&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/margin/transfer?email=&asset&amount&type&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/transfer/subToSub?toEmail=&asset&amount&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/transfer/subToMaster?asset&amount&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/transfer/subUserHistory?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/universalTransfer?fromAccountType=&toAccountType=&asset=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/universalTransfer?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/blvt/enable?email=&enableBlvt=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/subAccountApi/ipRestriction?email=&subAccountApiKey=&ipRestrict&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/sub-account/subAccountApi/ipRestriction/ipList?email=&subAccountApiKey=&ipAddress&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/sub-account/subAccountApi/ipRestriction?email=&subAccountApiKey=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/sapi/v1/sub-account/subAccountApi/ipRestriction/ipList?email=&subAccountApiKey=&ipAddress&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/managed-subaccount/deposit?toEmail=&asset=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/managed-subaccount/asset?email=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/managed-subaccount/withdraw?fromEmail=&asset=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/loan/income?asset=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/pay/transactions?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/convert/tradeFlow?startTime&endTime&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/rebate/taxQuery?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/api/v3/userDataStream'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('PUT', Uri.parse('https://api.binance.com/api/v3/userDataStream?listenKey='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/api/v3/userDataStream?listenKey='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/userDataStream/isolated?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('PUT', Uri.parse('https://api.binance.com/sapi/v1/userDataStream/isolated?listenKey=&symbol='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/sapi/v1/userDataStream/isolated?listenKey=&symbol'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/userDataStream'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('PUT', Uri.parse('https://api.binance.com/sapi/v1/userDataStream?listenKey='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/sapi/v1/userDataStream?listenKey='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/fiat/orders?transactionType=0&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/fiat/payments?transactionType=0&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/futures/transfer?asset=&amount=&type=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/transfer?asset=&startTime&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/borrow?coin=&amount=&collateralCoin=&collateralAmount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/borrow/history?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/repay?coin=&collateralCoin=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/repay/history?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/wallet?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v2/futures/loan/wallet?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/configs?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v2/futures/loan/configs?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/calcAdjustLevel?collateralCoin=&amount=&direction=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v2/futures/loan/calcAdjustLevel?loanCoin=&collateralCoin=&amount=&direction=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/calcMaxAdjustAmount?collateralCoin=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v2/futures/loan/calcMaxAdjustAmount?loanCoin=&collateralCoin=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/adjustCollateral?collateralCoin=&amount=&direction=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v2/futures/loan/adjustCollateral?loanCoin=&collateralCoin=&amount=&direction=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/adjustCollateral/history?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/liquidationHistory?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/collateralRepayLimit?coin=&collateralCoin=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/collateralRepay?coin=&collateralCoin=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/collateralRepay?quoteId=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/collateralRepayResult?quoteId=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/futures/loan/interestHistory?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/system/status'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/capital/config/getall?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/accountSnapshot?type=SPOT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/account/disableFastWithdrawSwitch?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/account/enableFastWithdrawSwitch?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/capital/withdraw/apply?coin=&address=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/capital/deposit/hisrec?coin=BTC&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/capital/withdraw/history?coin=BTC&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/capital/deposit/address?coin=BTC&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/account/status?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'X-MBX-APIKEY': 'api-key',
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/account/apiTradingStatus?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'X-MBX-APIKEY': 'api-key',
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/asset/dribblet?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/asset/dust?asset=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/asset/assetDividend?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'X-MBX-APIKEY': 'api-key',
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/asset/assetDetail?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/asset/tradeFee?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/asset/transfer?type=&asset=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/asset/transfer?type=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/asset/get-funding-asset?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/account/apiRestrictions?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/transfer?asset=&symbol=&transFrom=&transTo=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/transfer?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/account?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/pair?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/allPairs?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/account?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/account?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/isolated/accountLimit?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/margin/transfer?asset=BTC&amount&type&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/margin/loan?asset=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/margin/repay?asset=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/asset?asset=BTC'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/pair?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/allAssets'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/allPairs'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/priceIndex?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/margin/order?symbol=&side=&type=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/sapi/v1/margin/order?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/sapi/v1/margin/openOrders?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/transfer?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/loan?asset=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/repay?asset=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/interestHistory?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/forceLiquidationRec?startTime=&endTime=&isolatedSymbol=&current=1&size=10&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/account?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/order?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/openOrders?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/allOrders?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/myTrades?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/maxBorrowable?asset=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/maxTransferable?asset=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/bnbBurn?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/bnbBurn?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/interestRateHistory?asset=&recvWindow=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/margin/order/oco?symbol=BTCUSDT&side=&quantity=&price&stopPrice&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/sapi/v1/margin/orderList?symbol=BTCUSDT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/orderList?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/allOrderList?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/margin/openOrderList?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/ping'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/time'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/exchangeInfo'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/depth?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/trades?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/historicalTrades?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/aggTrades?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1m'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/avgPrice?symbol=BTCUSDT'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/ticker/24hr'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/ticker/price'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/ticker/bookTicker'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/pub/algoList?timestamp='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/pub/coinList?timestamp='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/worker/detail?algo=&userName=&workerName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/worker/list?algo=&userName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/payment/list?algo=&userName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/payment/other?algo=&userName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/hash-transfer/config/details/list?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/hash-transfer/profit/details?configId=&userName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/mining/hash-transfer/config?userName=&algo=&startDate=&endDate=&toPoolUser=&hashRate=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/mining/hash-transfer/config/cancel?configId=&userName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/statistics/user/status?algo=&userName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/mining/statistics/user/list?algo=&userName=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/daily/product/list?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/daily/userLeftQuota?productId=USDT001&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/lending/daily/purchase?productId=&amount=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/daily/userRedemptionQuota?productId=USDT001&type=FAST&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/lending/daily/redeem?productId=USDT001&amount&type&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/daily/token/position?asset=USDT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/project/list?type=ACTIVITY&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/lending/customizedFixed/purchase?projectId=&lot=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/project/position/list?asset=USDT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/union/account?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/union/purchaseRecord?lendingType=DAILY&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/union/redemptionRecord?lendingType=DAILY&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v1/lending/union/interestHistory?lendingType=DAILY&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/sapi/v1/lending/positionChanged?projectId=&lot=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/api/v3/order/test?symbol=BTCUSDT&side=SELL&type=LIMIT&quantity=0.01&price=9000&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/api/v3/order?symbol=BTCUSDT&side=SELL&type=LIMIT&quantity=0.01&price=9000&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/api/v3/order?symbol=BTCUSDT&orderId&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/api/v3/openOrders?symbol=&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/order?symbol=BTCUSDT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/openOrders?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/allOrders?symbol=BTCUSDT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('POST', Uri.parse('https://api.binance.com/api/v3/order/oco?symbol=BTCUSDT&side=&quantity=&price&stopPrice&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('DELETE', Uri.parse('https://api.binance.com/api/v3/orderList?symbol=BTCUSDT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/orderList?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/allOrderList?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/openOrderList?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/account?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/myTrades?symbol=BTCUSDT&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/api/v3/rateLimit/order?timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v2/sub-account/futures/account?email=&futuresType=1&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v2/sub-account/futures/accountSummary?futuresType=&page=1&limit=10&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

var headers = {
  'Content-Type': 'application/json',
  'X-MBX-APIKEY': 'api-key'
};
var request = http.Request('GET', Uri.parse('https://api.binance.com/sapi/v2/sub-account/futures/positionRisk?email=&futuresType=1&timestamp=&signature='));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

