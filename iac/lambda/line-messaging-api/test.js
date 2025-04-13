// test.js
require('dotenv').config();
const { handler } = require('./index');

const TEST_USER_ID = process.env.TEST_USER_ID;

(async () => {
  const event = {
    body: JSON.stringify({
      userId: TEST_USER_ID,
      text: 'Test message from the LINE Messaging API.'
    })
  };

  const result = await handler(event);
  console.log(result);
})();