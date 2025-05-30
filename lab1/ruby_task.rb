require 'json'
class Author
    attr_accessor :name, :age
end
class Book
    attr_accessor :title, :author, :ISBN, :count
    def initialize()
        @count = 1
    end
end
def save()
    File.write("inventory.json", "")
    data = []
    $books.each do |book|
        data.push({"author" => book.author.name, "title" => book.title, "ISBN" => book.ISBN, "count" => book.count.to_s})
        File.write("inventory.json",JSON.generate(data))
    end
end
def print_book(book)
    puts "#{book.title}, #{book.author.name}, #{book.ISBN} #{+book.count}"
end
$books = []
def list()
    puts "title, author, ISBN, count"
    $books.each do |book|
        print_book(book)
    end
end

def sorting()
    $books.sort_by! { |book| book.ISBN.to_i }
    save
end
def reverse()
    $books.reverse!
    save
end
def search_by_title(title)
    $books.each do |book|
        if book.title == title
            return book
        end
    end
end
def search_by_isbn(isbn)
ind = -1
    $books.each do |book|
        ind += 1
        if book.ISBN == isbn
            return ind
        end
    end
    -1
end
def add_book(book)
    if book.title == nil || book.author.name == nil || book.ISBN == nil
        puts "missing info"
        return false
    end 
    res = search_by_isbn(book.ISBN)
    puts "res = #{res} #{book.ISBN}"
    if res != -1
        count = $books[res].count
        $books[res] = book
        puts "before add" + $books[res].count.to_s
        $books[res].count = count + 1

        puts "book " + $books[+res].count.to_s
    else
        $books.push(book)
    end
    save
    puts "res" + res.to_s
    return true
end
def remove_book(isbin)
    ind = search_by_isbn(isbin)
    if ind != -1
        $books[ind].count -= 1
        if $books[ind].count == 0
            $books.delete_at(ind)
        end
        save
        return true
    end

    return false
end

def search_by_author(name)
    res = []
    $books.each do |book|
        if book.author.name == name
            res.push(book)
        end
    end
    return res
end
def load_books()
    data = JSON.parse(File.read("inventory.json"))
    data.each do |book|
        b = Book.new
        b.title = book["title"]
        b.author = Author.new
        b.author.name = book["author"]
        b.ISBN = book["ISBN"]
        b.count = book["count"].to_i
        $books.push(b)
    end
end
load_books()
while true
    puts "1. list books"
    puts "2. add book"
    puts "3. remove book"
    puts "4. search by title"
    puts "5. search by author"
    puts "6. search by ISBN"
    puts "7. sort by ISBN"
    puts "8. exit"
    c = gets.chomp.to_i
    case c
    when 1
        list()
    when 2
        puts "enter book title : "
        title = gets.chomp
        puts "enter book author : "
        author = gets.chomp
        puts "enter book ISBN : "
        isbn = gets.chomp
        b = Book.new
        b.title = title
        b.author = Author.new
        b.author.name = author
        b.ISBN = isbn
        add_book(b)
    when 3
        puts "enter book ISBN : "
        isbn = gets.chomp
        remove_book(isbn)
    when 4
        puts "enter book title : "
        title = gets.chomp
        book = search_by_title(title)
        if book != nil
            print_book(book)
        else
            puts "doesn't exist"
        end
    when 5
        puts "enter book author : "
        author = gets.chomp
        books = search_by_author(author)
        if books != nil
            books.each do |book|
                print_book(book)
            end
        else
            puts "doesn't exist"
        end
    when 6
        puts "enter book ISBN : "
        isbn = gets.chomp
        ind = search_by_isbn(isbn)
        puts "ind = #{ind}"
        if ind != -1
            print_book($books[ind])
        else
            puts "doesn't exist"
        end
    when 7
        sorting()
    when 8
        break
    when 9
        reverse()
    else
        puts "wrong choice"
    end
end 

