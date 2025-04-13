require('dotenv').config();
const { Client } = require('@line/bot-sdk');

const LINE_CHANNEL_ACCESS_TOKEN = process.env.LINE_CHANNEL_ACCESS_TOKEN;

const client = new Client({
  channelAccessToken: LINE_CHANNEL_ACCESS_TOKEN
});

exports.handler = async (event) => {
  try {
    const body = JSON.parse(event.body || '{}');
    const { userId, text } = body;

    if (!userId || !text) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'invalid payload' }),
      };
    }

    const message = {
      type: 'text',
      text: text,
    };

    await client.pushMessage(userId, message);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'sent message success' }),
    };
  } catch (e) {
    console.error('error: ', e);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: e.message }),
    };
  }
};