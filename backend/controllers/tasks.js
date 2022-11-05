const tasks_array = require("../models/tasksdata");
const user = require("../models/users");
const generateAddress = require("../utils/generateAddress");
const initializeWeb3Connection = require("../utils/initializeWeb3Connection");

let provider, contract;
initializeWeb3Connection().then(async ({ contract: ct, web3 }) => {
  contract = ct;
  provider = web3;
  // // const res = await contract.methods.createTask("Hello world").send({
  // //   from: "0x068Cea44Af30066b1f8dE4AbAc12a749d9ddaE26"
  // // });
  // const res = await contract.methods.getAllTasks().call();
  // // console.log(res);
});

exports.addtask = async (req, res) => {
  let wallet;
  try {
    const email = req.body.email;
    const result = await tasks_array
      .findOne({ email: email })
      .select("email")
      .lean();
    if (result) {
      const dates = new Date().toJSON().slice(0, 10);
      await tasks_array
        .findOne({ email: email })
        .updateOne({
          $push: {
            tasks: {
              id: req.body.id,
              task: req.body.task,
              iscompleted: false,
              datecreated: dates,
              datecompleted: "00-00-0000",
              deadline: req.body.deadline,
            },
          },
        })
        .exec();

      const resp = await tasks_array
        .find({ email: req.body.email })
        .select({ email: 0, _id: 0, __v: 0, coins: 0, tasks: 0 });
      wallet = resp[0]['wallet'];

      return res.status(201).json({
        message: "successful",
      });
    } else {
      const addressWallet = generateAddress().toString();
      const dates = new Date().toJSON().slice(0, 10);
      const Taskadd = new tasks_array({
        email: req.body.email,
        wallet: addressWallet,
        tasks: [
          {
            id: req.body.id,
            task: req.body.task,
            iscompleted: false,
            datecreated: dates,
            datecompleted: "00-00-0000",
            deadline: req.body.deadline,
          },
        ],
      });
      wallet = addressWallet;
      await Taskadd.save();
      return res.status(201).json({
        message: "task added",
      });
    }
  } catch (err) {
    return res.status(400).json({
      message: err.message,
    });}
   finally {
    const res = await contract.methods.createTask(wallet, req.body.task).send({
      from: "0x068Cea44Af30066b1f8dE4AbAc12a749d9ddaE26",
    });
    console.log(res);
  }
};

exports.gettask = async (req, res) => {
  try {
    const data = await tasks_array
      .find({ email: req.query.email })
      .select({ email: 0, _id: 0, __v: 0, coins: 0 });

    const tasks = data[0].tasks;

    return res.status(202).json({
      tasks,
    });
  } catch (err) {
    return res.status(404).json({
      message: err.message,
    });
  }
};

exports.deletetask = async (req, res) => {
  try {
    await tasks_array
      .findOne({ email: req.body.email })
      .updateOne({
        $pull: {
          tasks: {
            id: req.body.id,
          },
        },
      })
      .exec();
    return res.status(202).json({
      message: "deleted successfully",
    });
  } catch (err) {
    return res.status(404).json({
      message: err.message,
    });
  }
};

exports.complete = async (req, res) => {
  try {
    await tasks_array.findOne({ email: req.body.email }).updateOne(
      { "tasks.id": req.body.id },
      {
        $set: {
          "tasks.$.iscompleted": true,
        },
      }
    );
    const deadlines = await tasks_array.findOne({ email: req.body.email });
    deadlines.tasks.forEach(async (element) => {
      if (element.id == req.body.id) {
        const date = new Date();
        if (Date.parse(element.deadline) > date) {
          await user
            .findOne({ email: req.body.email })
            .updateOne({ $inc: { coins: 10 } });
          await tasks_array
            .findOne({ email: req.body.email })
            .updateOne({ $inc: { coins: 10 } });
        } else {
          await user
            .findOne({ email: req.body.email })
            .updateOne({ $inc: { coins: -10 } });
          await tasks_array
            .findOne({ email: req.body.email })
            .updateOne({ $inc: { coins: -10 } });
        }
      }
    });
    return res.status(202).json({
      message: "success",
    });
  } catch (err) {
    return res.status(404).json({
      message: err.message,
    });
  }
};

exports.modifytask = async (req, res) => {
  try {
    await tasks_array.findOne({ email: req.body.email }).updateOne(
      { "tasks.id": req.body.id },
      {
        $set: {
          "tasks.$.task": req.body.task,
        },
      }
    );
    return res.status(202).json({
      message: "success",
    });
  } catch (err) {
    return res.status(404).json({
      message: err.message,
    });
  }
};

exports.coins = async (req, res) => {
  try {
    const data = await user
      .find({ email: req.query.email })
      .select({ email: 0, _id: 0, password: 0, __v: 0 });
    return res.status(202).json({
      data,
    });
  } catch (err) {
    return res.status(404).json({
      message: err.message,
    });
  }
};
