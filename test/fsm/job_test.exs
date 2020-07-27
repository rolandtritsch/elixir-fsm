defmodule JobTest do
  use ExUnit.Case

  describe "test transitions" do
    test "created -> scheduled" do
      {:ok, id} = Job.start_link()
      assert {:ok, :scheduled} == :gen_statem.call(id, :schedule)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "scheduled -> initialized" do
      {:ok, id} = Job.start_link()
      assert {:ok, :scheduled} == :gen_statem.call(id, :schedule)
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "created -> initialized" do
      {:ok, id} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "initialized -> running" do
      {:ok, id} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:ok, :running} == :gen_statem.call(id, :run)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "running -> exit" do
      {:ok, id} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:ok, :running} == :gen_statem.call(id, :run)
      assert {:ok, :exit} == :gen_statem.call(id, :done)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "running -> processing" do
      {:ok, id} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:ok, :running} == :gen_statem.call(id, :run)
      assert {:ok, :processing} == :gen_statem.call(id, :process)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "processing -> running" do
      {:ok, id} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:ok, :running} == :gen_statem.call(id, :run)
      assert {:ok, :processing} == :gen_statem.call(id, :process)
      assert {:ok, :running} == :gen_statem.call(id, :success)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "processing -> failed" do
      {:ok, id} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:ok, :running} == :gen_statem.call(id, :run)
      assert {:ok, :processing} == :gen_statem.call(id, :process)
      assert {:ok, :failed} == :gen_statem.call(id, :failure)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end

    test "failed -> exit" do
      {:ok, id} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(id, :start)
      assert {:ok, :running} == :gen_statem.call(id, :run)
      assert {:ok, :processing} == :gen_statem.call(id, :process)
      assert {:ok, :failed} == :gen_statem.call(id, :failure)
      assert {:ok, :exit} == :gen_statem.call(id, :done)
      assert {:error, :invalid_transition} == :gen_statem.call(id, :xxx)
    end
  end
end
