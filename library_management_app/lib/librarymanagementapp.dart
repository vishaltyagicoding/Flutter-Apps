class Book {
  String id;
  String title;
  String author;
  String
  isbn; // International Standard Book Number - it's a unique 13-digit (or older 10-digit) identification number for books.
  bool? _isAvailable;
  DateTime? _dueDate;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
  }) : _isAvailable = true;

  bool get isAvailable => _isAvailable!;
  DateTime get dueDate => _dueDate!;

  set isAvailable(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  void borrowBook() {
    if (!isAvailable) {
      throw Exception("Book is already borrowed");
    }
    _dueDate = DateTime.now();
    isAvailable = false;
  }

  void returnBook() {
    if (getOverdueDuration()) {
      print("over due");
    }
    _isAvailable = true;
    _dueDate = null;
  }

  bool getOverdueDuration() {
    if (_dueDate == null || _isAvailable!) return false;
    Duration diffrent = DateTime.now().difference(_dueDate!);
    return (diffrent.inDays > 14);
  }
}

class Member {
  String id;
  String name;
  final List<Book> _borrowedBooks = [];
  Member({required this.id, required this.name});
  List<Book> get borrowedBooks => _borrowedBooks;

  void borrowBook(Book book) {
    if (borrowedBooks.length > 5) {
      throw Exception("You already gets 5 books");
    }
    if (!book.isAvailable) {
      throw Exception('Book "${book.title}" is not available');
    }
    _borrowedBooks.add(book);
    book.borrowBook();
  }

  void returnBook(Book book) {
    if (!_borrowedBooks.contains(book)) {
      throw Exception('$name did not borrow "${book.title}"');
    }
    borrowedBooks.remove(book);
    book.returnBook();
  }
}

class Library {
  final List<Book> _books = [];
  final List<Member> _members = [];

  List<Book> get books => _books;
  List<Member> get members => _members;

  void addBook(Book book) {
    book.isAvailable = true;
    _books.add(book);
  }

  void registerMember(Member member) {
    _members.add(member);
  }

  List<Book> findBookByTitle(String title) {
    return _books
        .where((book) => book.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  List<Book> findBooksByAuthor(String author) {
    return _books
        .where(
          (book) => book.author.toLowerCase().contains(author.toLowerCase()),
        )
        .toList();
  }

  List<Book> searchBooks(String query) {
    return _books
        .where(
          (book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  List<Book> getAvailableBooks() {
    return _books.where((book) => book.isAvailable).toList();
  }

  List<Member> getBorrowingReport() {
    List<Member> memberborrowedBooks = [];
    for (Member member in _members) {
      if (member.borrowedBooks.isNotEmpty) {
        memberborrowedBooks.add(member);
      }
    }
    return memberborrowedBooks;
  }

  Map<Member, List<Book>> getBorrowingMap() {
    final map = <Member, List<Book>>{};
    for (Member member in _members) {
      if (member.borrowedBooks.isNotEmpty) {
        map[member] = member.borrowedBooks;
      }
    }
    return map;
  }

  List<Book> getOverDueBooks() {
    return books.where((book) => book.isAvailable).toList();
  }
}

void main() {
  Library library = Library();
  library.addBook(
    Book(
      id: "B001",
      title: "Dart Programming",
      author: "John Doe",
      isbn: "978-1234567890",
    ),
  );
  // add books
  library.addBook(
    Book(
      id: 'B001',
      title: 'Dart Programming',
      author: 'John Doe',
      isbn: '978-1234567890',
    ),
  );
  library.addBook(
    Book(
      id: 'B002',
      title: 'Flutter Cookbook',
      author: 'Jane Smith',
      isbn: '978-0987654321',
    ),
  );
  library.addBook(
    Book(
      id: 'B003',
      title: 'Advanced Dart',
      author: 'John Doe',
      isbn: '978-1122334455',
    ),
  );
  library.addBook(
    Book(
      id: 'B004',
      title: 'Mobile Development',
      author: 'Alice Johnson',
      isbn: '978-5566778899',
    ),
  );
  library.addBook(
    Book(
      id: 'B005',
      title: 'Clean Code',
      author: 'Robert Martin',
      isbn: '978-0132350884',
    ),
  );

  // Register members
  library.registerMember(Member(id: "M002", name: "Alice"));
  library.registerMember(Member(id: "M002", name: "Bob"));
  library.registerMember(Member(id: "M001", name: "Vishal Tyagi"));

  try {
    final alice = library.members.firstWhere((m) => m.name == 'Alice');
    final bob = library.members.firstWhere((m) => m.name == 'Bob');
    try {
      final dartBook = library.findBookByTitle('Dart Programming').first;
      final flutterBook = library.findBookByTitle('Flutter Cookbook').first;
      final cleanCodeBook = library.findBookByTitle('Clean Code').first;
      alice.borrowBook(dartBook);
      bob.borrowBook(flutterBook);
      alice.borrowBook(cleanCodeBook);
      print('Books borrowed successfully!');
    } catch (e) {
      print(e);
    }
  } catch (e) {
    print("Member not found! $e");
  }

  print("Library Menagement System reports! ");
  print("Total Books:${library.books.length}");
  print("Availabel Books: ${library.getAvailableBooks().length}");
  print("Total Memeers: ${library.members.length}");
  print("Borroeds Books: ${library.getBorrowingReport().length}");

  for (Member member in library.getBorrowingReport()) {
    print("=============================================================");
    print("Borrowed deatils");
    print("borrowed by Member Name: ${member.name}");
    print("Member Id: ${member.id}");
    for (Book book in member.borrowedBooks) {
      print("book id: ${book.id}");
      print("book author: ${book.author}");
      print("book title: ${book.title}");
      print("book isbn: ${book.isbn}");

      final status = book.isAvailable ? ' (OVERDUE)' : 'NOT OVERDUE';
      print(status);
      print("=============================================================");
    }
  }
}
