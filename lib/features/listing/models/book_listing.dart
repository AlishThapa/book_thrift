import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';

class BookListing {
  BookListing({required this.id, required this.sellerId, required this.title, required this.author, required this.category, required this.subject, required this.institution, required this.classOrCourse, required this.semester, required this.edition, required this.publisher, this.isbn, required this.condition, required this.description, required this.originalPrice, required this.sellingPrice, required this.negotiable, required this.quantity, required this.imagePaths, required this.location, required this.deliveryMethod, required this.isAvailable, required this.isReserved, required this.status, required this.createdAt, required this.updatedAt});

  final String id; final String sellerId; final String title; final String author; final String category; final String subject;
  final String institution; final String classOrCourse; final String semester; final String edition; final String publisher; final String? isbn;
  final String condition; final String description; final double originalPrice; final double sellingPrice; final bool negotiable;
  final int quantity; final List<String> imagePaths; final String location; final List<String> deliveryMethod;
  final bool isAvailable; final bool isReserved; final String status; final DateTime createdAt; final DateTime updatedAt;

  BookListing copyWith({String? status, bool? isReserved, bool? isAvailable}) => BookListing(
        id: id, sellerId: sellerId, title: title, author: author, category: category, subject: subject, institution: institution,
        classOrCourse: classOrCourse, semester: semester, edition: edition, publisher: publisher, isbn: isbn, condition: condition,
        description: description, originalPrice: originalPrice, sellingPrice: sellingPrice, negotiable: negotiable, quantity: quantity,
        imagePaths: imagePaths, location: location, deliveryMethod: deliveryMethod, isAvailable: isAvailable ?? this.isAvailable,
        isReserved: isReserved ?? this.isReserved, status: status ?? this.status, createdAt: createdAt, updatedAt: DateTime.now(),
      );

  static BookListing sample(String id, String title, String author, String category, double original, double selling) => BookListing(
        id: id, sellerId: 'seller_1', title: title, author: author, category: category, subject: category, institution: 'Local College',
        classOrCourse: 'B.Tech', semester: '3', edition: '2nd', publisher: 'Academic Press', isbn: null, condition: 'Good',
        description: 'Well-maintained second hand academic book for students.', originalPrice: original, sellingPrice: selling,
        negotiable: true, quantity: 1, imagePaths: const [], location: 'Campus Area', deliveryMethod: const ['Meetup', 'Pickup'],
        isAvailable: true, isReserved: false, status: 'active', createdAt: DateTime.now().subtract(const Duration(days: 5)), updatedAt: DateTime.now(),
      );
}

class BookListingAdapter extends TypeAdapter<BookListing> {
  @override
  final int typeId = HiveTypeIds.bookListing;

  @override
  BookListing read(BinaryReader r) => BookListing(
      id: r.readString(), sellerId: r.readString(), title: r.readString(), author: r.readString(), category: r.readString(), subject: r.readString(),
      institution: r.readString(), classOrCourse: r.readString(), semester: r.readString(), edition: r.readString(), publisher: r.readString(),
      isbn: r.readBool()? r.readString():null, condition: r.readString(), description: r.readString(), originalPrice: r.readDouble(),
      sellingPrice: r.readDouble(), negotiable: r.readBool(), quantity: r.readInt(), imagePaths: (r.readList()).cast<String>(),
      location: r.readString(), deliveryMethod: (r.readList()).cast<String>(), isAvailable: r.readBool(), isReserved: r.readBool(),
      status: r.readString(), createdAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()), updatedAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()));

  @override
  void write(BinaryWriter w, BookListing o) {
    w..writeString(o.id)..writeString(o.sellerId)..writeString(o.title)..writeString(o.author)..writeString(o.category)..writeString(o.subject)
     ..writeString(o.institution)..writeString(o.classOrCourse)..writeString(o.semester)..writeString(o.edition)..writeString(o.publisher)
     ..writeBool(o.isbn!=null);
    if (o.isbn!=null) w.writeString(o.isbn!);
    w..writeString(o.condition)..writeString(o.description)..writeDouble(o.originalPrice)..writeDouble(o.sellingPrice)
     ..writeBool(o.negotiable)..writeInt(o.quantity)..writeList(o.imagePaths)..writeString(o.location)..writeList(o.deliveryMethod)
     ..writeBool(o.isAvailable)..writeBool(o.isReserved)..writeString(o.status)
     ..writeInt(o.createdAt.millisecondsSinceEpoch)..writeInt(o.updatedAt.millisecondsSinceEpoch);
  }
}
