defmodule BlogApp.CommentChannelTest do
  use BlogApp.Web.ChannelCase

  alias BlogApp.Repo
  alias BlogApp.Web.UserSocket
  alias BlogApp.Web.CommentChannel
  alias BlogApp.Blog

  def join_channel do
    # Create models
    user = insert(:user)
    post = insert(:post, user: user)

    # Create user token
    token = Phoenix.Token.sign(socket(), "user socket", user.id)
    {:ok, user_socket} = connect(UserSocket, %{"token" => token})

    # Subscribe to channel
    {:ok, _reply, socket} = subscribe_and_join(user_socket,
                                               "comments:#{post.id}", %{})

    # Reply with comment socket
    %{socket: socket, post: post}
  end

  setup do
    %{socket: socket, post: post} = join_channel()
    {:ok, socket: socket, post: post}
  end

  test "create comment succeeds with valid attrs", %{socket: socket, post: post} do
    attrs = params_for(:comment, post: post)
    payload = %{
      "postId" => post.id,
      "body" => attrs.body,
      "author" => attrs.author
    }
    push socket, "CREATED_COMMENT", payload
    assert_broadcast "CREATED_COMMENT", %{"body" => body, "author" => author, insertedAt: _}
  end

  test "create comment fails with invalid attrs", %{socket: socket, post: post} do
    attrs = params_for(:comment, post: post)
    {:ok, comment} = Blog.create_comment(post.id, attrs)
    payload = %{
      "postId" => post.id,
      "body" => comment.body,
      "author" => comment.author
    }
    ref = push socket, "CREATED_COMMENT", payload
    assert_reply ref, :error, %{message: [author_body: {"has already been taken", []}]}
  end

  # test "approve comment succeeds with admin auth", %{socket: socket, post: post} do
  # end
  #
  # test "approve comment fails without admin auth", %{socket: socket, post: post} do
  # end
  #
  # test "delete comment succeeds with user", %{socket: socket, post: post} do
  # end

end

