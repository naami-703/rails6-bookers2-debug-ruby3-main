$.ajax({
  url: '/comments', // コメントを取得するURL
  type: 'GET',
  data: { book_id: bookId },
  success: function(data) {
    $('#comment_area').html(data); // 取得したコメントを表示エリアに追加する
  }
});