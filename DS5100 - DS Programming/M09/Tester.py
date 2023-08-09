
import bookPackage as book

test_object = book.BookLover("Han Solo", "hsolo@millenniumfalcon.com", "scifi")
test_object.add_book("War of the Worlds", 4)
print(test_object.num_books_read())