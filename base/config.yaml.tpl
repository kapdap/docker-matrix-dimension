web:
  address: "HOST_ADDRESS"
  port: HOST_PORT

homeserver:
  name: "HOME_NAME"
  clientServerUrl: "HOME_MATRIX_URL"
  federationUrl: "HOME_FEDERATION_URL"
  mediaUrl: "HOME_MEDIA_URL"
  accessToken: "HOME_ACCESS_TOKEN"

admins: ADMIN_LIST

widgetBlacklist: WIDGET_BLACKLIST

database:
  file: "DATABASE_FILE"

goneb:
  avatars:
    giphy: "mxc://t2bot.io/c5eaab3ef0133c1a61d3c849026deb27"
    imgur: "mxc://t2bot.io/6749eaf2b302bb2188ae931b2eeb1513"
    github: "mxc://t2bot.io/905b64b3cd8e2347f91a60c5eb0832e1"
    wikipedia: "mxc://t2bot.io/7edfb54e9ad9e13fec0df22636feedf1"
    travisci: "mxc://t2bot.io/7f4703126906fab8bb27df34a17707a8"
    rss: "mxc://t2bot.io/aace4fcbd045f30afc1b4e5f0928f2f3"
    google: "mxc://t2bot.io/636ad10742b66c4729bf89881a505142"
    guggy: "mxc://t2bot.io/e7ef0ed0ba651aaf907655704f9a7526"
    echo: "mxc://t2bot.io/3407ff2db96b4e954fcbf2c6c0415a13"
    circleci: "mxc://t2bot.io/cf7d875845a82a6b21f5f66de78f6bee"
    jira: "mxc://t2bot.io/f4a38ebcc4280ba5b950163ca3e7c329"

logging:
  console: LOG_CONSOLE
  consoleLevel: LOG_LEVEL
  writeFiles: LOG_FILE
  file: LOG_PATH
  fileLevel: FILE_LEVEL
  rotate:
    size: LOG_SIZE
    count: LOG_COUNT