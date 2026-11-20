// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AttendanceRecord {
    address public instructor;
    string public courseTitle;

    mapping(address => bool) public hasAttended;
    address[] public attendees;

    // Event triggered when attendance is recorded or removed
    event AttendanceRecorded(address indexed student, uint256 timestamp);
    event AttendanceRemoved(address indexed student);

    constructor(string memory _courseTitle) {
        instructor = msg.sender;
        courseTitle = _courseTitle;
    }

    // Allows only the instructor to perform specific actions
    modifier onlyInstructor() {
        require(
            msg.sender == instructor,
            "Only the instructor can perform this action."
        );
        _;
    }

    // Records a student's attendance
    function recordAttendance(address _student) external onlyInstructor {
        require(_student != address(0), "Invalid student address.");
        require(!hasAttended[_student], "Student is already recorded.");

        hasAttended[_student] = true;
        attendees.push(_student);

        emit AttendanceRecorded(_student, block.timestamp);
    }

    // Returns the total number of attendees
    function getAttendeeCount() external view returns (uint256) {
        return attendees.length;
    }

    // Checks if a student has attended
    function isAttending(address _student) external view returns (bool) {
        return hasAttended[_student];
    }

    // Removes a student's attendance. Only the instructor can call this.
    function removeAttendance(address _student) external onlyInstructor {
        require(hasAttended[_student], "Student has not attended.");

        hasAttended[_student] = false;

        for (uint256 i = 0; i < attendees.length; i++) {
            if (attendees[i] == _student) {
                attendees[i] = attendees[attendees.length - 1];
                attendees.pop();
                break;
            }
        }

        emit AttendanceRemoved(_student);
    }

    // Returns the complete list of attendees
    function getAttendees() external view returns (address[] memory) {
        return attendees;
    }
}
