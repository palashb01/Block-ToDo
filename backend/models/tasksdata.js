const mongoose = require("mongoose");
const taskSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unqiue: true,
  },
  coins:{
    type:Number,
    default:100
  },
  wallet:{
    type: String,
    required: true,
  },
  tasks:[{
    id:String,
    task:String,
    iscompleted:false,
    datecreated:Date,
    datecompleted:String,
    deadline:String
   }]
});

const tasks_array = new mongoose.model("Tasks", taskSchema);

module.exports = tasks_array;