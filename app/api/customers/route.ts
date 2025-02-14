import { NextResponse } from "next/server";
import prisma from "@/lib/prisma";

export async function GET(){
    try{
        const customers = await prisma.customer.findMany({})
        return NextResponse.json(customers)
    } catch (error) {
      console.error('Request error', error)
      return NextResponse.json({ error: 'Error fetching customers' }, { status: 500 })
    }
}