const express = require('express');
const app = express();
const morgan = require('morgan');
const db = require('./Config/DatabaseConfig.js');

app.set('port',process.env.PORT || 3000);

//middlewares
app.use(morgan('dev'));
app.use(express.urlencoded)
app.use(express.json());

//routes
app.use('/users', require('./Routes/Users'));

//starting the server
app.listen(app.get('port'),() => {
    console.log(`Server on port ${3000}`)
});