import pandas as pd

class BookLover:
    """
    BookLover class allows user to record books they have read
    
    ...
    Attributes:
    name string name of reader
    email string email of reader (unique identifier)
    fav_genre string fav genre of reader
    num_books int optional number of books read (default 0)
    book_list list of book titles (string) and ratings (float) (default empty list)
    
    ...
    Methods:
    __init__ initialize a Booklover object with name, email, fav_genre, numbooks, and book_list
    add_book allows user to add a book name and rating to book_list if the title is not already in the list
    has_read returns boolean value for if a book name is in book_list
    num_books_read returns the number of books in the book_list
    fav_books returns dataframe of books with rating larger than 3 from book_list
    """
    
    def __init__(self, name, email, fav_genre, numbooks=0,
                 book_list=pd.DataFrame({'book_name':[], 'book_rating':[]})):
        self.name = name
        self.email = email
        self.fav_genre = fav_genre
        self.numbooks = numbooks
        self.book_list = book_list
        
        
    def add_book(self, book_name, book_rating):
        new_book = pd.DataFrame({'book_name': [book_name], 
                                 'book_rating': [book_rating]})
        
        #check if book_name is already in the book list
        if new_book['book_name'].values not in self.book_list['book_name'].values:
            self.book_list = pd.concat([self.book_list, new_book], 
                                   ignore_index=True)
            self.numbooks += 1
        else:
            print('This book is already in the list!')
            
            
    def has_read(self, book_name):
        return (book_name in self.book_list['book_name'].values)

    
    def num_books_read(self):
        return self.book_list.shape[0]
        
        
    def fav_books(self):
        return self.book_list.query("book_rating > 3").reset_index()
        

if __name__ == '__main__':
    
    test_object = BookLover("Han Solo", "hsolo@millenniumfalcon.com", "scifi")
    test_object.add_book("War of the Worlds", 4)
    print(test_object.book_list)
    print(test_object.book_list.book_rating)
    print(test_object.fav_books())
    test_object.add_book('Han Solo', 2)
    print(test_object.book_list)
    test_object.add_book("War of the Worlds", 1)
    print(test_object.has_read('Han Solo'))
    print(test_object.num_books_read())
    
    # And so forth