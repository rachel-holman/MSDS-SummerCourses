import unittest
import pandas as pd
from booklover import BookLover

class BookLoverTestSuite(unittest.TestCase):
    
    def test_1_add_book(self): 
        # add a book and test if it is in `book_list`.
        test_object = BookLover("Rachel H", "dnw9qk@virginia.edu", "romcom")
        test_object.add_book("All The Light We Cannot See", 4)
        
        #extract elements as list and ensure they are the same
        actual = [test_object.book_list['book_name'][0],
                  test_object.book_list['book_rating'][0]]
        expected = ["All The Light We Cannot See", 4.0]
        self.assertEqual(actual, expected)

        
    def test_2_add_book(self):
        # add the same book twice. Test if it's in `book_list` only once.
        test_object = BookLover("Rachel H", "dnw9qk@virginia.edu", "romcom")
        test_object.add_book("To Kill a Mockingbird", 3)
        test_object.add_book("To Kill a Mockingbird", 5)
        self.assertEqual(test_object.book_list.shape[0], 1)
                
            
    def test_3_has_read(self): 
        # pass a book in the list and test if the answer is `True`.
        test_object = BookLover("Rachel H", "dnw9qk@virginia.edu", "romcom")
        test_object.add_book("The Great Gatsby", 3.2)
        self.assertEqual(test_object.has_read("The Great Gatsby"), True)
        
        
    def test_4_has_read(self): 
        # pass a book NOT in the list and use `assert False` to test the answer is `True`
        test_object = BookLover("Rachel H", "dnw9qk@virginia.edu", "romcom")
        test_object.add_book("Little Women", 2)
        self.assertFalse(test_object.has_read("The Great Gatsby"), True)
        
        
    def test_5_num_books_read(self): 
        # add some books to the list, and test num_books matches expected.
        test_object = BookLover("Rachel H", "dnw9qk@virginia.edu", "romcom")
        test_object.add_book("Little Women", 2)
        test_object.add_book("The Great Gatsby", 3.2)
        test_object.add_book("To Kill a Mockingbird", 3)
        test_object.add_book("All The Light We Cannot See", 4)
        test_object.add_book("The Invisible Life of Addie LaRue", 5)
        self.assertEqual(test_object.num_books_read(), 5)
        self.assertEqual(test_object.numbooks, 5)
        self.assertEqual(test_object.num_books_read(), test_object.numbooks)

        
    def test_6_fav_books(self):
        # add some books with ratings to the list, making sure some of them have rating > 3. 
        # Your test should check that the returned books have rating  > 3
        test_object = BookLover("Rachel H", "dnw9qk@virginia.edu", "romcom")
        test_object.add_book("Little Women", 2)
        test_object.add_book("The Great Gatsby", 3.2)
        test_object.add_book("To Kill a Mockingbird", 3)
        test_object.add_book("All The Light We Cannot See", 4)
        test_object.add_book("The Invisible Life of Addie LaRue", 5)
        
        favs = test_object.fav_books()
        actual = [favs['book_rating'][x]>3 for x in range(favs.shape[0])]
        self.assertTrue(actual, test_object.fav_books().shape[0]*[True])
                
            
if __name__ == '__main__':
    
    unittest.main(verbosity=3)