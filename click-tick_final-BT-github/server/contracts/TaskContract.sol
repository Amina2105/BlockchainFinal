// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.4;
contract TaskContract {

    event AddTask(address recipient, uint taskId);
    event DeleteTask(uint taskId, bool isDeleted);

    struct Task {
        uint id;
        address username;
        string taskText;
        string taskDescription;
        bool isDeleted;
    }

    Task[] private tasks; // Array to store all tasks

    // Mapping of todo id to the wallet address of the user
    mapping(uint256 => address) taskToOwner;

    // Method to be called by our frontend when trying to add a new todo
    function addTask(string memory taskText, string memory taskDescription, bool isDeleted) external {
        uint taskId = tasks.length; // Get the current task ID as the length of the tasks array
        tasks.push(Task(taskId, msg.sender, taskText, taskDescription, isDeleted)); // Create a new Task object and add it to the tasks array
        taskToOwner[taskId] = msg.sender; // Map the task ID to the wallet address of the user
        emit AddTask(msg.sender, taskId); // Emit the AddTask event with the user's address and the task ID
    }

// Temporary array to store tasks that belong to the caller and are not deleted
    function getMyTasks() external view returns (Task[] memory) {
        Task[] memory temporary = new Task[](tasks.length);
        uint counter = 0;
        for(uint i=0; i<tasks.length; i++) {
            if(taskToOwner[i] == msg.sender && tasks[i].isDeleted == false) {
                temporary[counter] = tasks[i];
                counter++;
            }
        }

        Task[] memory result = new Task[](counter); // Create a new array with only the valid tasks from the temporary array

        for(uint i=0; i<counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    // Method to Delete a todo
    function deleteTask(uint taskId, bool isDeleted) external {
        if(taskToOwner[taskId] == msg.sender) {
            tasks[taskId].isDeleted = isDeleted;
            emit DeleteTask(taskId, isDeleted);
        }
    }

}