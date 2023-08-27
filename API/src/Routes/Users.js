const { Router } = require('express');
const router = new Router();
const conn = require('../Config/DatabaseConfig');

router.get('/', (req, res) => {
    const sql = 'SELECT * FROM Users';

    conn.query(sql, (error, results) => {
        
        if (results.length > 0) {
            res.json(results);
        }
        else if (error){
            res.send(error.message);
            return;
        }
        else{
          res.statusCode = 202;
          res.send('No se encontraron usuarios');
          return;
        }
        });
});

router.get('/:id', (req, res) => {
    const { id } = req.params;
    const sql = `SELECT * FROM Users WHERE id = '${id}'`;

    conn.query(sql, (error, results) => {
        
        if (results.length > 0) {
            res.json(results[0]);
        }
        else if (error){
            res.send(error.message);
            return;
        }
        else{
          res.statusCode = 202;
          res.send('No se encontraron usuarios');
          return;
        }
        });
});

router.post('/add', (req, res) => {
    const sql = 'INSERT INTO Users SET ?';
  
    const userJson = {
        id: req.body.id,
        email: req.body.email,
        password: req.body.password,
        phone_number: req.body.phone_number,
        address: req.body.address,
        first_name: req.body.first_name,
        middle_name: (req.body.middle_name.length <= 0  ? undefined : req.body.middle_name),
        surname: req.body.surname,
        second_surname: (req.body.second_surname.length <= 0 ? undefined : req.body.second_surname),
        role: req.body.role
    };

    conn.query(sql, userJson, error => {
        if (error){
            res.statusCode = 202; 
            res.send(error.sqlMessage);
            return;
        }
        res.send(`Se ha añadido al usuario '${userJson.id}'`);
    });

  });


module.exports = router;