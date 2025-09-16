import mongoose from "mongoose"

export const dbConnection = async () => {
    try {
        await mongoose.connect(process.env.DB_STRING)
        console.log("connected to database")
    } catch (error) {
        console.log(error, "something went wrong")
    }

}