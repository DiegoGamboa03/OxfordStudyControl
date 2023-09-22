const { Router } = require('express');
const router = new Router();
const conn = require('../Config/DatabaseConfig');

router.get('/:student_id', (req, res) => {
    const { student_id } = req.params;
    const sql = `SELECT G.*
    FROM Grades AS G
    JOIN Exams AS E ON G.exam_id = E.name
    WHERE G.student_id = '${student_id}'
    ORDER BY E.required_block, G.test_date;
    `;

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
          res.send('No se encontraron examenes');
          return;
        }
        });
});

module.exports = router;