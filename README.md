<p align="center">
  <img alt="logo" src="https://github.com/MassimoTambu/binander/blob/main/android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png" />
</p>

<p align="center">
    <img alt="MIT License" src="https://img.shields.io/github/license/MassimoTambu/binander">
    <img alt="Code Size" src="https://img.shields.io/github/languages/code-size/MassimoTambu/binander">
</p>

# Binander

**Keep in mind this project is still unstable and I am not responsible of any losses or malfunction. If you want to test it, please create bots in the Binance Testnet network.**

This app is a personal experiment created to help some friends with daily trading on crypto.
You can create multiple bots connected to a crypto pair (like BTC-USDC) and they will able to submit orders with Binance APIs.

Right now there is ony one type of bot called "minimizes losses" that with a custom configuration will submit and move a sell order every time the price goes higher than a specified percentage. This will **not** working well in a bearish market.

## Features

- Create multiple bots
- Check bot status
- Working on Binance pubnet and testnet
- Working with Binance API
- Cross platform (tested on MacOS and Windows)
- Light/dark mode toggle


## Run Locally

Clone the project

```bash
  git clone https://github.com/MassimoTambu/binander.git
```

Go to the project directory

```bash
  cd binander
```

Install dependencies

```bash
  flutter pub get
```

Generate *.freezed and *.g dart files

```bash
  flutter pub run build_runner watch
```
