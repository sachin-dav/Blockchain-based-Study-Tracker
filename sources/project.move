module MyModule::StudyTracker {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::vector;

    /// Struct representing a student's study progress
    struct StudyProgress has store, key {
        total_study_hours: u64,        // Total hours studied
        study_sessions: vector<u64>,   // Timestamps of study sessions
        current_streak: u64,           // Current consecutive days of study
        longest_streak: u64,           // Longest streak achieved
    }

    /// Function to initialize a student's study tracker
    public fun create_study_tracker(student: &signer) {
        let progress = StudyProgress {
            total_study_hours: 0,
            study_sessions: vector::empty<u64>(),
            current_streak: 0,
            longest_streak: 0,
        };
        move_to(student, progress);
    }

    /// Function to log a study session with hours studied
    public fun log_study_session(student: &signer, hours: u64) acquires StudyProgress {
        let student_addr = signer::address_of(student);
        let progress = borrow_global_mut<StudyProgress>(student_addr);
        
        // Get current timestamp
        let current_time = timestamp::now_seconds();
        
        // Add study session timestamp
        vector::push_back(&mut progress.study_sessions, current_time);
        
        // Update total study hours
        progress.total_study_hours = progress.total_study_hours + hours;
        
        // Update streak logic (simplified: increment streak for each session)
        progress.current_streak = progress.current_streak + 1;
        
        // Update longest streak if current streak is higher
        if (progress.current_streak > progress.longest_streak) {
            progress.longest_streak = progress.current_streak;
        };
    }

    /// Function to get student's study statistics
    public fun get_study_stats(student_addr: address): (u64, u64, u64, u64) acquires StudyProgress {
        let progress = borrow_global<StudyProgress>(student_addr);
        (
            progress.total_study_hours,
            vector::length(&progress.study_sessions),
            progress.current_streak,
            progress.longest_streak
        )
    }
}