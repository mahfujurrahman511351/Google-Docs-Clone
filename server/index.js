const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const http = require("http");
const cors= require("cors");
const documentRouter = require("./routes/document");

const PORT = process.env.PORT || 3002; 

const app = express();

var server = http.createServer(app);

var io = require("socket.io")(server);

app.use(cors());

app.use(express.json());

app.use(authRouter);

app.use(documentRouter);


const DB = "mongodb+srv://mahfujurrahmancu:mahfujurrahman.anik@cluster0.vygvttr.mongodb.net/your-database-name?retryWrites=true&w=majority";

mongoose.set('strictQuery', true);

mongoose.connect(DB)
  .then(() => {
    console.log("Yeah! Connection Successful");
  })
  .catch((err) => {
    console.log(err);
  });

  io.on("connection", (socket) => {
  socket.on("join", (documentId) => {
    socket.join(documentId);
    console.log("Joined");
  });
  });
 
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected successfully at port ${PORT}`);
});  

