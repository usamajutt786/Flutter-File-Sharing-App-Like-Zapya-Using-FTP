const express = require('express');
const fileUpload = require('express-fileupload');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const app = express();

app.use(cors());
app.use(fileUpload());

const uploadDirectory = 'uploads';

// Create the 'uploads' directory if it doesn't exist
if (!fs.existsSync(uploadDirectory)) {
  fs.mkdirSync(uploadDirectory);
}

app.post('/upload', (req, res) => {
  if (!req.files || Object.keys(req.files).length === 0) {
    return res.status(400).send('No files were uploaded.');
  }

  try {
    let uploadedFile = req.files.file;
    const fileName = path.join(uploadDirectory, uploadedFile.name);

    uploadedFile.mv(fileName, (err) => {
      if (err) {
        console.error('Error saving file:', err);
        return res.status(500).send(err);
      }
      console.log('File received and saved:', fileName);
      res.send(`File uploaded to: ${fileName}`);
    });
  } catch (err) {
    console.error('File processing error:', err);
    return res.status(500).send(err);
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
