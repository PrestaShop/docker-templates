import express from 'express';
import { readdir, readFile } from 'node:fs/promises';
import cors from 'cors';

const app = express();
const port = 3000;

app.use(cors());

app.get('/sql_dumps', async (req, res) => {
    try {
        const files = await readdir('../dumps/');
        const SQLFiles = files.filter(file => file.endsWith('.sql'));
        res.json(SQLFiles);
    } catch (error) {
        console.error('Error on reading folder :', error);
        res.status(500).send('Error on reading folder');
    }
});

app.get('/sql_dump_content', async (req, res) => {
    const fileName = req.query.fileName; // Get the file name from the query parameters

    try {
        const content = await readFile(`../dumps/${fileName}`, 'utf-8');
        res.send(content);
    } catch (error) {
        console.error('Error while reading file:', error);
        res.status(500).send('Error while reading file');
    }
});

app.listen(port, () => {
    console.log(`Server started on port ${port}`);
});
