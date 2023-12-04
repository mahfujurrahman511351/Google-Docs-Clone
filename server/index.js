const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const cors= require("cors");

const PORT = process.env.PORT || 3001; // Using || instead of |

const app = express();

app.use(cors());

app.use(express.json());

app.use(authRouter);


const DB = "mongodb+srv://mahfujurrahmancu:mahfujurrahman.anik@cluster0.vygvttr.mongodb.net/your-database-name?retryWrites=true&w=majority";

mongoose.connect(DB)
  .then(() => {
    console.log("Yeah! Connection Successful");
  })
  .catch((err) => {
    console.log(err);
  });


app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected successfully at port ${PORT}`);
});
