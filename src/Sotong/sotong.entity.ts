import { Field, ObjectType } from '@nestjs/graphql';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@ObjectType()
@Entity()
export class Sotong {
    @Field(() => Number) // nest(gql)
    @PrimaryGeneratedColumn()
    id: number;

    @Field(() => String) // nest(gql)
    @Column()
    name: string;

    @Field(() => String) // nest(gql)
    @Column()
    hello: string;
}
