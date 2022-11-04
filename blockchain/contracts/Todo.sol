// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Todo {
    /* Type declarations */
    struct Task {
        uint256 id;
        address creator;
        string message;
        bool completed;
        uint256 createdAt;
        uint256 completedAt;
    }

    /* State variables */
    uint256 private taskId;

    Task[] private tasks;
    mapping(address => uint256[]) private addressToTasks;
    mapping(uint256 => address) private taskToAddress;

    /* Events */
    event TaskAdded(
        uint256 indexed taskId,
        address indexed creator,
        string indexed message
    );
    event TaskToggled(
        uint256 indexed taskId,
        address indexed creator,
        bool indexed status
    );

    /* Functions */
    constructor() {
        taskId = 0;
    }

    function createTask(address user, string calldata _content) public {
        tasks.push(
            Task({
                id: taskId,
                creator: user,
                message: _content,
                completed: false,
                createdAt: block.timestamp,
                completedAt: 0
            })
        );
        addressToTasks[user].push(taskId);
        taskToAddress[taskId] = user;

        taskId++;

        emit TaskAdded(taskId, user, _content);
    }

    function toggleTask(uint256 _taskId) public {
        tasks[_taskId].completed = !tasks[_taskId].completed;

        emit TaskToggled(_taskId, tasks[_taskId].creator, tasks[_taskId].completed);
    }

    function setTaskStatus(uint256 _taskId, bool _status) public {
        tasks[_taskId].completed = _status;
        tasks[_taskId].completedAt = block.timestamp;

        emit TaskToggled(_taskId, tasks[_taskId].creator, _status);
    }

    function completeTask(uint256 _taskId) public {
        tasks[_taskId].completed = true;
        tasks[_taskId].completedAt = block.timestamp;

        emit TaskToggled(_taskId, tasks[_taskId].creator, true);
    }

    /* Getters */
    function getUserTasks(address _user) public view returns (Task[] memory) {
        uint256 length = addressToTasks[_user].length;

        Task[] memory taskListOfAUser = new Task[](length);
        uint256 index = 0;

        for (uint256 i = 0; i < length; i++) {
            uint256 _taskId = addressToTasks[_user][i];
            taskListOfAUser[index] = (tasks[_taskId]);
            index++;
        }

        return taskListOfAUser;
    }

    function getAllTasks() public view returns (Task[] memory) {
        return tasks;
    }

    function getTask(uint256 _taskId) public view returns (Task memory) {
        return tasks[_taskId];
    }

    function getTaskName(uint256 _taskId) public view returns (string memory) {
        return tasks[_taskId].message;
    }

    function getTaskStatus(uint256 _taskId) public view returns (bool) {
        return tasks[_taskId].completed;
    }

    function getTaskOwner(uint256 _taskId) public view returns (address) {
        return tasks[_taskId].creator;
    }
}
