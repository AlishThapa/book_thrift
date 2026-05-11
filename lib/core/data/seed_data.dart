import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/notifications/models/app_notification.dart';

class SeedData {
  static List<BookListing> listings() => [
        BookListing.sample('1', 'Calculus for Engineers', 'R. K. Jain', 'Engineering', 18, 8),
        BookListing.sample('2', 'NCERT Physics Class 12', 'NCERT', 'School', 12, 4),
        BookListing.sample('3', 'Organic Chemistry Guide', 'Morrison', 'Entrance Prep', 20, 9),
        BookListing.sample('4', 'Data Structures in C++', 'Sahni', 'Computer Science', 25, 11),
      ];

  static UserProfile guestProfile() => UserProfile(
        fullName: 'Guest Reader',
        email: 'guest@local.app',
        phone: '0000000000',
        userType: 'reader',
        institutionName: 'Community',
        classOrCourse: 'General Reader',
        semesterOrYear: 'N/A',
        location: 'Your City',
        imagePath: '',
      );

  static List<ChatThread> threads() => [
        ChatThread.sample(),
      ];

  static List<AppNotification> notifications() => [
        AppNotification.sample('n1', 'New message', 'A seller replied to your chat.'),
        AppNotification.sample('n2', 'Item saved', 'You saved Calculus for Engineers.'),
      ];
}
