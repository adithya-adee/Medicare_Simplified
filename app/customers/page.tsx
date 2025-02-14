"use client";
import { Customer } from "@/types/customer";
import { useEffect, useState } from "react";

export default function CustomersPage() {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function getCustomers() {
      try {
        const res = await fetch(`http://localhost:3000/api/customers`, {
          cache: "no-store",
        });

        if (!res.ok) {
          throw new Error("Failed to fetch customers");
        }

        const data = await res.json();
        setCustomers(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to fetch customers");
      } finally {
        setLoading(false);
      }
    }

    getCustomers();
  }, []);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <>
      <h1>Customers</h1>
      {customers.map((customer) => (
        <div key={customer.id}>{customer.name}</div>
      ))}
    </>
  );
}