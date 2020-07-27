defmodule JobTest do
  use ExUnit.Case

  describe "test transitions" do
    test "created -> scheduled" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :scheduled} == :gen_statem.call(pid, :schedule)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "scheduled -> initialized" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :scheduled} == :gen_statem.call(pid, :schedule)
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "created -> initialized" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "initialized -> running" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:ok, :running} == :gen_statem.call(pid, :run)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "running -> exit" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:ok, :running} == :gen_statem.call(pid, :run)
      assert {:ok, :exit} == :gen_statem.call(pid, :done)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "running -> processing" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:ok, :running} == :gen_statem.call(pid, :run)
      assert {:ok, :processing} == :gen_statem.call(pid, :process)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "processing -> running" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:ok, :running} == :gen_statem.call(pid, :run)
      assert {:ok, :processing} == :gen_statem.call(pid, :process)
      assert {:ok, :running} == :gen_statem.call(pid, :success)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "processing -> failed" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:ok, :running} == :gen_statem.call(pid, :run)
      assert {:ok, :processing} == :gen_statem.call(pid, :process)
      assert {:ok, :failed} == :gen_statem.call(pid, :failure)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end

    test "failed -> exit" do
      {:ok, pid} = Job.start_link()
      assert {:ok, :initialized} == :gen_statem.call(pid, :start)
      assert {:ok, :running} == :gen_statem.call(pid, :run)
      assert {:ok, :processing} == :gen_statem.call(pid, :process)
      assert {:ok, :failed} == :gen_statem.call(pid, :failure)
      assert {:ok, :exit} == :gen_statem.call(pid, :done)
      assert {:error, "invalid transition"} == :gen_statem.call(pid, :xxx)
    end
  end
end
