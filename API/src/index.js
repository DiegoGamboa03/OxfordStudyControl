const express = require('express');
const app = express();
const morgan = require('morgan');
const db = require('./Config/DatabaseConfig.js');
const { Storage } = require('@google-cloud/storage');

app.set('port',process.env.PORT || 3000);

//middlewares
app.use(morgan('dev'));
app.use(express.urlencoded({
    extended: true
  }));
app.use(express.json());

//configs 

const storage = new Storage({
  keyFilename: 'src/Config/superb-cubist-399908-453a1e0fb313.json',
});

//routes
app.use('/users', require('./Routes/Users'));
app.use('/exams', require('./Routes/Exams'));
app.use('/lessons', require('./Routes/Lessons'));
app.use('/blocks', require('./Routes/Blocks.js'));
app.use('/onlineClasses', require('./Routes/OnlineClasses.js'));
app.use('/grades', require('./Routes/Grades.js'));

//starting the server
app.listen(app.get('port'),() => {
    console.log(`Server on port ${3000}`);
});