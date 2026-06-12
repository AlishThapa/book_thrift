import 'package:hive/hive.dart';
import 'package:book_thrift/core/hive/hive_type_ids.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:book_thrift/core/utils/json_helper.dart';

class BookListing {
  BookListing({required this.id, required this.sellerId, required this.title, required this.author, required this.category, required this.subject, required this.institution, required this.classOrCourse, required this.semester, required this.edition, required this.publisher, this.isbn, required this.condition, required this.description, required this.originalPrice, required this.sellingPrice, required this.negotiable, required this.quantity, required this.imagePaths, required this.location, required this.deliveryMethod, required this.isAvailable, required this.isReserved, required this.status, required this.createdAt, required this.updatedAt, this.owner, this.isWishlisted = false, this.similarBooks});

  final String id; final String sellerId; final String title; final String author; final String category; final String subject;
  final String institution; final String classOrCourse; final String semester; final String edition; final String publisher; final String? isbn;
  final String condition; final String description; final double originalPrice; final double sellingPrice; final bool negotiable;
  final int quantity; final List<String> imagePaths; final String location; final List<String> deliveryMethod;
  final bool isAvailable; final bool isReserved; final String status; final DateTime createdAt; final DateTime updatedAt;
  final UserProfile? owner;
  final bool isWishlisted;
  final List<BookListing>? similarBooks;

  BookListing copyWith({String? status, bool? isReserved, bool? isAvailable, UserProfile? owner, bool? isWishlisted, List<BookListing>? similarBooks}) => BookListing(
        id: id, sellerId: sellerId, title: title, author: author, category: category, subject: subject, institution: institution,
        classOrCourse: classOrCourse, semester: semester, edition: edition, publisher: publisher, isbn: isbn, condition: condition,
        description: description, originalPrice: originalPrice, sellingPrice: sellingPrice, negotiable: negotiable, quantity: quantity,
        imagePaths: imagePaths, location: location, deliveryMethod: deliveryMethod, isAvailable: isAvailable ?? this.isAvailable,
        isReserved: isReserved ?? this.isReserved, status: status ?? this.status, createdAt: createdAt, updatedAt: DateTime.now(),
        owner: owner ?? this.owner,
        isWishlisted: isWishlisted ?? this.isWishlisted,
        similarBooks: similarBooks ?? this.similarBooks,
      );

  static BookListing sample(String id, String title, String author, String category, double original, double selling) => BookListing(
        id: id, sellerId: 'seller_1', title: title, author: author, category: category, subject: category, institution: 'Local College',
        classOrCourse: 'B.Tech', semester: '3', edition: '2nd', publisher: 'Academic Press', isbn: null, condition: 'Good',
        description: 'Well-maintained second hand academic book for students.', originalPrice: original, sellingPrice: selling,
        negotiable: true, quantity: 1, imagePaths: const [], location: 'Campus Area', deliveryMethod: const ['Meetup', 'Pickup'],
        isAvailable: true, isReserved: false, status: 'active', createdAt: DateTime.now().subtract(const Duration(days: 5)), updatedAt: DateTime.now(),
      );

  factory BookListing.fromJson(Map<String, dynamic> json) {
    final data = json['data'] != null ? json['data'] as Map<String, dynamic> : json;
    return BookListing(
      id: JsonHelper.toStringValue(data['id'] ?? '') ?? '',
      sellerId: JsonHelper.toStringValue(data['owner_id'] ?? data['seller_id'] ?? '') ?? '',
      title: JsonHelper.toStringValue(data['title']) ?? '',
      author: JsonHelper.toStringValue(data['author']) ?? 'Unknown',
      category: JsonHelper.toStringValue(data['category']) ?? 'Others',
      subject: JsonHelper.toStringValue(data['subject']) ?? 'General',
      institution: JsonHelper.toStringValue(data['institution']) ?? '',
      classOrCourse: JsonHelper.toStringValue(data['class_name']) ?? '',
      semester: JsonHelper.toStringValue(data['semester']) ?? '',
      edition: JsonHelper.toStringValue(data['edition']) ?? '',
      publisher: JsonHelper.toStringValue(data['publisher']) ?? '',
      isbn: JsonHelper.toStringValue(data['isbn']),
      condition: JsonHelper.toStringValue(data['condition']) ?? 'Good',
      description: JsonHelper.toStringValue(data['description']) ?? '',
      originalPrice: JsonHelper.toDouble(data['original_price']) ?? 0.0,
      sellingPrice: JsonHelper.toDouble(data['price'] ?? data['selling_price']) ?? 0.0,
      negotiable: JsonHelper.toBool(data['negotiable']) ?? true,
      quantity: JsonHelper.toInt(data['quantity']) ?? 1,
      imagePaths: (data['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      location: JsonHelper.toStringValue(data['location']) ?? 'Unknown',
      deliveryMethod: (data['delivery_method'] as List?)?.map((e) => e.toString()).toList() ?? ['Meetup'],
      isAvailable: JsonHelper.toBool(data['is_available']) ?? true,
      isReserved: JsonHelper.toBool(data['is_reserved']) ?? false,
      status: JsonHelper.toStringValue(data['status']) ?? 'active',
      createdAt: JsonHelper.toDate(data['created_at']) ?? DateTime.now(),
      updatedAt: JsonHelper.toDate(data['updated_at']) ?? DateTime.now(),
      owner: data['owner'] != null ? UserProfile.fromJson(data['owner']) : null,
      isWishlisted: JsonHelper.toBool(data['is_wishlisted']) ?? false,
      similarBooks: (data['similar_books'] as List?)?.map((e) => BookListing.fromJson(e)).toList(),
    );
  }
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
      status: r.readString(), createdAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()), updatedAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()),
      owner: r.availableBytes > 0 ? r.read() as UserProfile? : null,
      isWishlisted: r.availableBytes > 0 ? r.readBool() : false);

  @override
  void write(BinaryWriter w, BookListing o) {
    w..writeString(o.id)..writeString(o.sellerId)..writeString(o.title)..writeString(o.author)..writeString(o.category)..writeString(o.subject)
     ..writeString(o.institution)..writeString(o.classOrCourse)..writeString(o.semester)..writeString(o.edition)..writeString(o.publisher)
     ..writeBool(o.isbn!=null);
    if (o.isbn!=null) w.writeString(o.isbn!);
    w..writeString(o.condition)..writeString(o.description)..writeDouble(o.originalPrice)..writeDouble(o.sellingPrice)
     ..writeBool(o.negotiable)..writeInt(o.quantity)..writeList(o.imagePaths)..writeString(o.location)..writeList(o.deliveryMethod)
     ..writeBool(o.isAvailable)..writeBool(o.isReserved)..writeString(o.status)
     ..writeInt(o.createdAt.millisecondsSinceEpoch)..writeInt(o.updatedAt.millisecondsSinceEpoch)
     ..write(o.owner)
     ..writeBool(o.isWishlisted);
  }
}
