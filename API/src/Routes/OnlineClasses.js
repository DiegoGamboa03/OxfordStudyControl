const { Router } = require('express');
const router = new Router();
const conn = require('../Config/DatabaseConfig');

router.get('/getAvailableOnlineClasses', (req, res) => {
    
    /*const sql = `
    SELECT * FROM OnlineClasses 
    WHERE TIME(NOW()) <= start_time
    AND available_positions > 0
    AND DAYOFWEEK(NOW()) BETWEEN 2 AND 6`;
*/
    const sql = `
    SELECT *, 
    CONCAT(CURDATE(), ' ', OnlineClasses.start_time) AS start_date,
    CONCAT(CURDATE(), ' ', OnlineClasses.end_time) AS end_date
    FROM OnlineClasses
    WHERE TIME(NOW()) <= start_time
    AND available_positions > 0;`;

    

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
          res.send('No se encontraron clases online');
          return;
        }
    });
});

router.post('/makeReservation', (req, res) => {
    const sql = 'INSERT INTO StudentsClassesReservation SET ?';
  
    const reservationJson = {
        online_class_id: req.body.online_class_id,
        student_id: req.body.student_id
    };

    conn.query(sql, reservationJson, error => {
        if (error){
            if(error.sqlMessage == 'No hay posiciones disponibles'){
                res.statusCode = 403
                res.send('No hay puestos disponibles');
                return;
            }
            res.statusCode = 202; 
            res.send(error.sqlMessage);
            return;
        }
        res.send(`Se ha reservado '${reservationJson.online_class_id}'`);
    });

});


module.exports = router;