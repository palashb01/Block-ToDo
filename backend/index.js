const express = require("express");
const cors = require("cors");

require("dotenv").config();
require("./db/conn");

const app = express();
const port = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

const tasks = require("./controllers/tasks");
const userss = require("./controllers/user");

app.post("/addUser", userss.adduser);
app.post("/loginuser", userss.loginuser);
app.post("/addtask", tasks.addtask);
app.get("/gettask", tasks.gettask);
app.delete("/deletetask", tasks.deletetask);
app.put("/complete", tasks.complete);
app.put("/modifytask", tasks.modifytask);
app.get("/getcoins", tasks.coins);
app.use("/", (req, res) => {
  res.send(
    "<html><head><title>Block Todo</title></head><body style='height: 100vh; width: 100vw; display: flex; justift-content: center; align-items: center;'><h1>Welcome to Block { ToDo }</h1></body></html>"
  );
});

app.listen(port, () => {
  console.log("server is running on port " + port);
});
