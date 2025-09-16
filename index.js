import express from "express"
import cors from 'cors'
import dotenv from "dotenv";

dotenv.config();

import {dbConnection} from './database/db.js'

import todosRoutes from './routes/todos.routes.js'
import authRoutes from './routes/auth.routes.js'

const app =  express()

app.use(express.json())
app.use(cors())

try {
	await dbConnection();
} catch (error) {
	console.error("Failed to connect to the database:", error);
}

app.use("/todos", todosRoutes)
app.use("/auth", authRoutes)

app.listen(process.env.WB_PORT, () => console.log(`connected to the port ${process.env.WB_PORT}`))